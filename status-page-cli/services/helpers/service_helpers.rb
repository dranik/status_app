module ServiceHelpers
  def ok_or_fail(flag)
    if flag
      puts 'OK!'.green
    else
      puts 'Fail'.red
    end
  end
end
