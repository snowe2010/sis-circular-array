module SisCircularArray
  class SisCircularArray

    def initialize s, big_s=80, item=8000, setup=1000, hold=25, shortage=700, file
      @inventory_level_at_time = []
      @order_at_time = []
      @demand_at_time = []
      @s = s
      @S = big_s
      @item_cost, @setup, @hold, @shortage = item, setup, hold, shortage
      @time_averaged_holding_level, @time_averaged_shortage_level = 0, 0
      @time_averaged_holding_level_array = []
      @time_averaged_shortage_level_array = []

      @file = file
    end
    
    def algorithm_1_3_1
      @inventory_level_at_time[0] = S;
      i = 0;
      while (more_demand)
        i += 1
        if @inventory_level_at_time[i-1] < s
          @order_at_time[i-1] = S - @inventory_level_at_time[i-1]
        else
          @order_at_time[i-1] = 0                    
        end
        @demand_at_time[i] = get_demand
        @inventory_level_at_time[i] = @inventory_level_at_time[i-1] + @order_at_time[i-1] - @demand_at_time[i]
      end
      @order_at_time[i] = S - @inventory_level_at_time[i] 
      @inventory_level_at_time[i] = S
      return @inventory_level_at_time, @order_at_time
    end
    
    def get_demand
      File.foreach(@file) { |line|  }
    end

    def get_average_demand size
      @demand_at_time.inject(:+) / @demand_at_time.size  #summation of all members of demand from 1 to size divided by size
    end

    def get_average_order size
      @order_at_time.inject(:+) / @order_at_time.size # sum of all members of order from 1 to size divided by size 
    end

    def time_averaged_holding_level 
      @time_averaged_holding_level = @time_averaged_holding_level_array.inject(:+) / @time_averaged_holding_level_array.size
    end

    def time_average_shortage_level
      @time_average_shortage_level = @time_averaged_shortage_level_array.inject(:+) / @time_averaged_shortage_level_array.size
    end

    def calculate_time_averaged_holding_level_array_for_each_time_interval
      # l'_(i-1) = l_(i-1) + o_(i-1)
      @time_averaged_holding_level_array = @inventory_level_at_time.zip(@order_at_time, @demand_at_time).each_with_index.map do |inventory_level, order, demand, index|
        ((l_prime)**2)/(2*demand)
      end
    end

    def calculate_time_averaged_shortage_level_array_for_each_time_interval
      @time_averaged_shortage_level_array = @inventory_level_at_time.zip(@order_at_time, @demand_at_time).each_with_index.map do |inventory_level, order, demand, index|
        ((demand - l_prime)**2)/(2*demand)
      end
    end

    def l_prime index
      @inventory_level_at_time[index-1] + @order_at_time[i-1]
    end
  end
end
