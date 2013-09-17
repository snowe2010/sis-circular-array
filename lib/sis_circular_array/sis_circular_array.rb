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

      File.foreach(file) { |line| @demand << line.to_i }
      @demand.compact
      @n = @demand.size.to_f
      # class << self; puts @demand; end
      # puts @demand
    end
    
    def algorithm_1_3_1
      @inventory_level_at_time[0] = @S;
      i = 0;
      while (@demand.size > 0)
        i += 1
        if @inventory_level_at_time[i-1] < @s
          @order_at_time[i-1] = @S - @inventory_level_at_time[i-1]
        else
          @order_at_time[i-1] = 0                  
        end
        @demand_at_time[i] = get_demand
        @inventory_level_at_time[i] = @inventory_level_at_time[i-1] + @order_at_time[i-1] - @demand_at_time[i]
      end
      n = i
      @order_at_time[n] = @S - @inventory_level_at_time[n]
      @inventory_level_at_time[n] = @S
      return @inventory_level_at_time, @order_at_time
    end

    def get_demand
      @demand.shift
    end

    def average_demand
      @demand_at_time.reduce(:+) / @n #summation of all members of demand from 1 to size divided by size
    end

    def average_order
      @order_at_time.reduce(:+) / @n # sum of all members of order from 1 to size divided by size 
    end

    def time_averaged_holding_level 
      time_averaged_holding_level_array.reduce(:+) / @n
    end

    def time_averaged_shortage_level
      time_averaged_shortage_level_array.reduce(:+) / @n
    end

    def order_frequency
      @order_at_time.count { |e| e != 0 } / @n
    end

    private 

    def time_averaged_holding_level_array
      # l'_(i-1) = l_(i-1) + o_(i-1)
      i = 0
      l_plus = []
      while i < @n
        i += 1 
        if @demand_at_time[i] <= l_prime(i)
          l_plus << (l_prime(i) - (@demand_at_time[i]/2)).round
        else
          l_plus << (((l_prime(i))**2)/(2 * @demand_at_time[i].to_f)).round
        end
      end

      l_plus

      # @inventory_level_at_time.zip(@order_at_time, @demand_at_time).drop(1).each_with_index.map do |zipped, index|
      #   inventory_level, order, demand  = zipped
      #   if demand < l_prime(index)
      #     (l_prime(index) - (demand/2)).round(2)
      #   else
      #     ((l_prime(index))**2)/(2 * demand.to_f).round(2)
      #   end
      # end.compact
    end

    def time_averaged_shortage_level_array
      i = 0
      l_minus = []
      while i < @n
        i += 1 
        if @demand_at_time[i] > l_prime(i)
          l_minus << ( ( ( @demand_at_time[i] - l_prime(i) )**2 ) / ( 2 * @demand_at_time[i].to_f ) ).round
        end
      end
      l_minus

      # @inventory_level_at_time.zip(@order_at_time, @demand_at_time).drop(1).each_with_index.map do |zipped, index|
      #   inventory_level, order, demand  = zipped
      #   if demand > l_prime(index)
      #     ((demand - l_prime(index))**2)/(2 * demand.to_f).round(2)
      #   end
      # end.compact

    end

    def l_prime index
      @inventory_level_at_time[index-1] + @order_at_time[index-1]
    end
  end
end

class RingBuffer < Array
  attr_reader :max_size
 
  def initialize(max_size, enum = nil)
    @max_size = max_size
    enum.each { |e| self << e } if enum
  end
 
  def <<(el)
    if self.size < @max_size || @max_size.nil?
      super
    else
      self.shift
      self.push(el)
    end
  end
 
  alias :push :<<
end
