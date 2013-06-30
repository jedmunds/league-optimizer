require 'yaml'
begin
  $y = YAML.load_file('items.yaml')
  # load our YAML items file containing ALL THE INFO we will ever need

  @stats = $y['stat_costs']
  @v = Hash.new
  @stats.each do |stat|
    @v.key(stat.keys[0])
    @v[stat.keys[0]] = stat.values[0]
  end
  # loop through the YAML file to find stat costs, write to a variable 
  # called @v, which is a hash.

  @stats = {
    'item_names' =>             [""],
    'ability_power' =>             0,
    'armor' =>                     0,
    'rmor_penetration_flat' =>     0,
    'armor_penetration_percent' => 0,
    'attack_damage' =>             0,
    'attack_speed' =>              0,
    'cooldown_reduction' =>        0,
    'cost_total' =>                0,
    'critical_strike_chance' =>    0,
    'health' =>                    0,
    'health_regeneration' =>       0,
    'life_steal' =>                0,
    'magic_penetration_flatt' =>   0,
    'magic_resist' =>              0,
    'mana' =>                      0,
    'mana_regeneration' =>         0,
    'movement_speed' =>            0,
    'spell_vamp' =>                0,
    'tenacity' =>                  0,
  }

  def cost_efficiency(hash)
    total_value = 0
    hash.each do |key, value|
      if value != 0 and value.is_a? Float and key != "cost_total"
        total_value += value * @v[key]
      end
    end
    return total_value
  end

  def find_item(string)
    items = $y['items']
    items.each do |item|
     
      values = item.values[0]
      nickname = values[27]["nicknames"][0]
      name = values[26]["name"]
      key_val = item.keys[0] 

      if nickname == string or name == string or key_val == string
        values.each do |value|
          if value.values[0].is_a? Float
            if @stats[value.keys[0]].nil? == false
              @stats[value.keys[0]] += value.values[0]
            end
          end
        end
      end
    end
  end

  items = $y['items']
  # load just the 'items' section of the YAML, there are two others

  item_to_find = gets
  item_to_find = item_to_find.gsub("\n","")

  find_item item_to_find
  cost_e = cost_efficiency(@stats)
  cost_e_s = cost_e.to_i.to_s
  cost_t = @stats['cost_total']
  cost_t_s = cost_t.to_i.to_s
  puts "The cost efficiency of your item base stats is #{cost_e_s}" +
        " and the total item cost is #{cost_t_s},\n so you have a" +
        " cost efficiency of " + (cost_e/cost_t).to_s + ", a higher" +
        " number is better.\nA number greater than 1 is amazing."

rescue Exception => e
  puts e.message
  puts e.backtrace.inspect
end
