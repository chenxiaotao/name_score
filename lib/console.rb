#encoding: utf-8
module Console

  @@mutex = Mutex.new

  def puts(message, color = nil)
    @@mutex.lock
    Dir.mkdir("#{LOG_PATH}") unless Dir.exists?("#{LOG_PATH}")
    logfile = File.open("#{LOG_PATH}/name_score.log", File::WRONLY | File::APPEND | File::CREAT)
    logfile << message.to_s
    super(message.to_s.colorize(color: color))
    logfile.close
    @@mutex.unlock
  end

  def puts_info message
    puts message, :green
  end

  def puts_warning message
    puts message, :yellow
  end
  
  def puts_result(message)
    @@mutex.lock
    Dir.mkdir("#{LOG_PATH}") unless Dir.exists?("#{LOG_PATH}")
    logfile = File.open("#{LOG_PATH}/name_result.log", File::WRONLY | File::APPEND | File::CREAT)
    logfile << message.to_s + "\n"
    logfile.close
    @@mutex.unlock
  end

  def puts_error message
    puts message, :red
  end

  def print message, options = {}
    stdout = options[:stdout].nil? ? true : options[:stdout] #默认是true
    color = options[:color] || :yellow
    mutex_locked = options[:mutex].try(:locked?)

    @@mutex.lock unless mutex_locked #如果调用者没有获得锁,那么要先申请锁

    logfile = File.open("#{LOG_PATH}/name_score.log", File::WRONLY | File::APPEND | File::CREAT)
    logfile << message.to_s
    super(message.to_s.colorize(color: color)) if stdout
    logfile.close

    @@mutex.unlock unless mutex_locked
  end

  def get_input(options={})
    tip_msg = options[:tip_msg] || ' 请输入：'
    reject_massage = options[:reject_massage] || '输入不正确，请重新输入：'
    allows = options[:allows].map { |i| i.to_s } if options[:allows]

    @@mutex.lock #锁住,防止并发要求输入
    print "\n#{tip_msg}", mutex: @@mutex
    while input = STDIN.gets.strip
      print "#{input.to_s}\n", stdout: false, mutex: @@mutex
      break if input.empty? && options[:allow_empty]     #允许回车
      if allows && allows.length > 0                     #如果有限定输入
        if allows.include? input
          break
        else
          print reject_massage, mutex: @@mutex unless input.empty?
        end
      elsif !input.empty?                               #没有限定输入，输入不正确不为空
        break
      end

    end
    @@mutex.unlock

    input
  end
end
