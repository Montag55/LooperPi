
# Loopes
Input = Struct.new(:name, :key, :signal, :state, :c1, :c2, :c3, :c4, :k1, :k2, :k3, :k4)

loop_1 = Input.new("Loop_1", 89, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)
loop_2 = Input.new("Loop_2", 90, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)
loop_3 = Input.new("Loop_3", 91, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)
loop_4 = Input.new("Loop_4", 92, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)

$array_pos = nil
$arrayMatch = [lb_1 = 0, loop_1, lb_2 = 0, loop_2, lb_3 = 0, loop_3, lb_4 = 0, loop_4]
$masterVolume = 1.00;
$sleep_t = 0.1

sound_kits = {
  drums: {
    hat:   :drum_cymbal_closed,
    kick:  :drum_bass_hard,
    snare: :drum_snare_hard,
    padel: :drum_cymbal_pedal
  },
  acoustic_soft: {
    hat:   :drum_cymbal_closed,
    kick:  :drum_bass_soft,
    snare: :drum_snare_soft
  },
  electro: {
    hat:   :elec_triangle,
    kick:  :elec_soft_kick,
    snare: :elec_hi_snare
  },
  toy: {
    hat:   :elec_tick,
    kick:  :elec_hollow_kick,
    snare: :elec_pop
  }
}
in_thread(name: :looper) do
  #Handle inputs
  live_loop :midi_input_manager do
    use_real_time
    key, value = sync "/midi/mixtrack_pro_ii/0/1/note_on"

    if (key == 89)
      puts "handle_loop1"
      handle_loop($arrayMatch[1], key, value)

    end
    if (key == 90)
      puts "handle_loop2"
      puts key
      puts value
      handle_loop($arrayMatch[3], key, value)

    end
    if (key == 91)
      puts "handle_loop3"
      handle_loop($arrayMatch[5], key, value)

    end
    if (key == 92)
      puts "handle_loop4"
      handle_loop($arrayMatch[7], key, value)

    end

    if (key == 64 && value == 127)
      loop_1 = Input.new("Loop_1", 89, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)
      loop_2 = Input.new("Loop_2", 90, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)
      loop_3 = Input.new("Loop_3", 91, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)
      loop_4 = Input.new("Loop_4", 92, 0, 0, [0], [0] ,[0] ,[0], 0, 0, 0, 0)
      $arrayMatch = [lb_1 = 0, loop_1, lb_2 = 0, loop_2, lb_3 = 0, loop_3, lb_4 = 0, loop_4]
    end


    play_loop $arrayMatch[1], :drums
    play_loop $arrayMatch[3], :toy
    play_loop $arrayMatch[5], :electro
    play_loop $arrayMatch[7], :acoustic_soft
    puts $masterVolume

  end
end


def handle_loop (loop, key, value)

  #first time pressed
  if (loop[:state] == 0)

    loop[:state] = 1
    loop[:signal] = value
    loop[:c1] = Array.new
    loop[:c2] = Array.new
    loop[:c3] = Array.new
    loop[:c4] = Array.new

    #define length and first filling
    while (loop[:signal] == 127)

      loop[:c1].push(loop[:k1])
      loop[:k1] = 0

      loop[:c2].push(loop[:k2])
      loop[:k2] = 0

      loop[:c3].push(loop[:k3])
      loop[:k3] = 0

      loop[:c4].push(loop[:k4])
      loop[:k4] = 0

      sleep $sleep_t
    end
  else
    count = 0
    bool_1 = 0
    bool_2 = 0
    bool_3 = 0
    bool_4 = 0
    tmp_1 = Array.new(loop[:c1].size(), 0)
    tmp_2 = Array.new(loop[:c2].size(), 0)
    tmp_3 = Array.new(loop[:c3].size(), 0)
    tmp_4 = Array.new(loop[:c4].size(), 0)

    while(count < loop[:c1].size() && loop[:signal] == 127)

      if(loop[:k1] != 0)
        bool_1 = 1
        tmp_1[count] = loop[:k1]
        loop[:k1] = 0
      end
      if(loop[:k2] != 0)
        bool_2 = 1
        tmp_2[count] = loop[:k2]
        loop[:k2] = 0
      end
      if(loop[:k3] != 0)
        bool_3 = 1
        tmp_3[count] = loop[:k3]
        loop[:k3] = 0
      end
      if(loop[:k4] != 0)
        bool_4 = 1
        tmp_4[count] = loop[:k4]
        loop[:k4] = 0
      end

      count = count + 1
      sleep $sleep_t
    end


    if(bool_1 == 1)
      loop[:c1] = tmp_1
    end
    if(bool_2 == 1)
      loop[:c2] = tmp_2
    end
    if(bool_3 == 1)
      loop[:c3] = tmp_3
    end
    if(bool_4 == 1)
      loop[:c4] = tmp_4
    end

  end
end

live_loop :update_array_pos do
  use_real_time
  key, value = sync "/midi/mixtrack_pro_ii/0/1/note_on"

  if(key == 89 && value == 127)
    $array_pos = 0
    $arrayMatch[$array_pos + 1][:signal] = value
    puts "loop 1"
  elsif(key == 90 && value == 127)
    $array_pos = 2
    $arrayMatch[$array_pos + 1][:signal] = value
    puts "loop 2"
  elsif(key == 91 && value == 127)
    $array_pos = 4
    $arrayMatch[$array_pos + 1][:signal] = value
    puts "loop 3"
  elsif(key == 92 && value == 127)
    $array_pos = 6
    $arrayMatch[$array_pos + 1][:signal] = value
    puts "loop 4"
  elsif((key == 89 || key == 90 || key == 91 || key == 92) && value == 0)
    $arrayMatch[$array_pos + 1][:signal] = value
    $array_pos = nil
  end
end



live_loop :update_loops do
  use_real_time
  key, value = sync "/midi/mixtrack_pro_ii/0/1/note_on"

  if($array_pos != nil)
    if($arrayMatch[$array_pos] == 0)
      $arrayMatch[$array_pos] = 1
    else
      $arrayMatch[$array_pos] = 0
    end

    if(key == 83 && $arrayMatch[$array_pos] == 1)
      $arrayMatch[$array_pos + 1][:k1] = 7
    end

    if(key == 84 && $arrayMatch[$array_pos] == 1)
      $arrayMatch[$array_pos + 1][:k2] = 7
    end

    if(key == 85 && $arrayMatch[$array_pos] == 1)
      $arrayMatch[$array_pos + 1][:k3] = 7
    end

    if(key == 99 && $arrayMatch[$array_pos] == 1)
      $arrayMatch[$array_pos + 1][:k4] = 7
    end
  end
end

live_loop :update_volume do
  use_real_time
  key, value = sync "/midi/mixtrack_pro_ii/0/1/control_change"

  if(key == 23)
    $masterVolume = value
  end
end


define :play_loop do |loop, kit|
  live_loop loop[:name] do
    for i in 0..loop[:c1].length - 1
      sample sound_kits[kit][:hat], amp: ($masterVolume * loop[:c1][i])/(9.0 * 127)
      sample sound_kits[kit][:kick], amp: ($masterVolume * loop[:c2][i])/(9.0 * 127)
      sample sound_kits[kit][:snare], amp: ($masterVolume * loop[:c3][i])/(9.0 * 127)
      sample sound_kits[kit][:padel], amp: ($masterVolume * loop[:c4][i])/(9.0 * 127)
      sleep $sleep_t
    end
  end
end
