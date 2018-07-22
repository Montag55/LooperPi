
pattern =  [40, 0, 0, 40, 0, 0, 40, 0, 0, 40]
pattern1 = [0, 0, 0, 80, 0, 0, 80, 0, 0, 0]
pattern2 = [50, 0, 0, 0, 0, 0, 0, 0, 0, 50]
pattern3 = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1]




def play_pat (name, p, synth)
  live_loop name do
    use_synth synth
    play_pattern_timed p,[0.1]
  end
end

def update_pat (pat, name)
  live_loop name do
    for i in 0..pat.length - 1
      pat[i] = pat[i]
    end
    sleep 0.1
  end
end


play_pat(:foo, pattern1, :piano)
play_pat(:boo, pattern1, :beep)
play_pat(:too, pattern1, :pluck)
play_pat(:goo, pattern1, :hollow)

play_pat(:aoo, pattern, :piano)
play_pat(:coo, pattern, :beep)
play_pat(:doo, pattern, :pluck)
play_pat(:eoo, pattern, :hollow)

play_pat(:hoo, pattern2, :dtri)
play_pat(:ioo, pattern2, :piano)
play_pat(:koo, pattern2, :beep)
play_pat(:loo, pattern2, :pluck)

play_pat(:moo, pattern3, :hollow)
play_pat(:noo, pattern3, :dtri)
play_pat(:qoo, pattern3, :dtri)
play_pat(:joo, pattern3, :dtri)

update_pat(pattern, :up)
update_pat(pattern2, :shlap)
update_pat(pattern1, :kack)
update_pat(pattern3, :fuck)
