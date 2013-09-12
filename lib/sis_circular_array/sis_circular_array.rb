module SisCircularArray
  class SisCircularArray
    attr_accessor :item_cost, :setup, :hold, :shortage

    def self.get_demand file
      @demand = []
      File.foreach(file) { |line| @demand << line }
      @demand
    end

    def initialize s, file, big_s=80, item=8000, setup=1000, hold=25, shortage=700
      @inventory_level_at_time = []
      @order_at_time = []
      @demand_at_time, @demand = [], []
      @s = s
      @S = big_s
      @item_cost, @setup, @hold, @shortage = item, setup, hold, shortage
      @time_averaged_holding_level, @time_averaged_shortage_level = 0, 0

      File.foreach(file) { |line| @demand << line.to_i }
      @demand.compact
      @n = @demand.size
      # class << self; puts @demand; end
      # puts @demand
    end
    
    def algorithm_1_3_1
      @inventory_level_at_time[0] = @S;
      i = 0;
      while (@demand.size>0)
        i += 1
        if @inventory_level_at_time[i-1] < @s
          @order_at_time[i-1] = @S - @inventory_level_at_time[i-1]
        else
          @order_at_time[i-1] = 0                    
        end
        @demand_at_time[i] = get_demand
        @inventory_level_at_time[i] = @inventory_level_at_time[i-1] + @order_at_time[i-1] - @demand_at_time[i]
      end
      @order_at_time[i] = @S - @inventory_level_at_time[i] 
      @inventory_level_at_time[i] = @S
      return @inventory_level_at_time, @order_at_time
    end

    def get_demand
      @demand.pop
    end

    def average_demand
      @demand_at_time.inject(:+).to_f / @demand_at_time.size  #summation of all members of demand from 1 to size divided by size
    end

    def average_order
      @order_at_time.inject(:+).to_f / @order_at_time.size # sum of all members of order from 1 to size divided by size 
    end

    def time_averaged_holding_level 
      @time_averaged_holding_level = time_averaged_holding_level_array.inject(:+).to_f / @n
    end

    def time_averaged_shortage_level
      @time_average_shortage_level = time_averaged_shortage_level_array.inject(:+).to_f / @n
    end

    def order_frequency
      @order_at_time.reject { |e| e==0 }.size.to_f / @n
    end

    private 

    def time_averaged_holding_level_array
      # l'_(i-1) = l_(i-1) + o_(i-1)
      return @inventory_level_at_time.zip(@order_at_time, @demand_at_time).drop(1).each_with_index.map do |zipped, index|
        inventory_level, order, demand  = zipped
        # puts "index : #{index}"
        # puts "inventory_level, order, demand : #{inventory_level} , #{order} , #{demand}"
        # demand = 0 if demand.nil?
        ((l_prime(index))**2)/(2*demand.to_f)
      end
    end

    def time_averaged_shortage_level_array
      return @inventory_level_at_time.zip(@order_at_time, @demand_at_time).drop(1).each_with_index.map do |zipped, index|
        # puts "index : #{index}"
        inventory_level, order, demand  = zipped
        # demand = 0 if demand.nil?
        ((demand - l_prime(index))**2)/(2*demand.to_f)
      end
    end

    def l_prime index
      # puts index
      @inventory_level_at_time[index-1] + @order_at_time[index-1]
    end
  end
end
