#encoding: utf-8
class UserConfig
  extend Console
  include Console
  attr_accessor :first_name, :lock_word, :sex, :birthday, :province, :city, :name_size, :limit_size

  def initialize(options)
    self.first_name = options[:first_name]
    self.lock_word  = options[:lock_word] || ''
    self.sex        = options[:sex]
    self.birthday   = options[:birthday]
    self.province   = options[:province]
    self.city       = options[:city]
    self.name_size  = options[:name_size]
    self.limit_size = options[:name_size].to_i - options[:lock_word].size - options[:first_name].size
  end

  def valid?
    if self.limit_size < 0
      puts_error "你的名字总长度小于了姓和固定的名字, 请检查并重新输入"
      return false
    end

    begin
      Time.parse(self.birthday)
    rescue
      puts_error "时间输出有误, 请检查并重新输入"
      return false
    end
    true
  end

  def message_print
    message = "你的贵姓是 '#{self.first_name}'\n"
    if self.lock_word == ''
      message += "你名字中没有想要的字\n"
    else
      message += "你名字想要有 '#{self.lock_word}'\n"
    end
    message += "性别为 '#{self.sex}'\n"
    message += "出生日期为 '#{self.birthday}'\n"
    message += "出生地点为  #{self.province} #{self.city}\n"
    message += "名字总长度为: #{self.name_size}"
    puts_info message
  end

  class << self

    def current
      @user_current ||= init_user
    end

    def init_user
      options = get_input_message
      user = self.new(options)
      unless user.valid?
        return init_user
      end

      user.message_print
      case get_input(allows: ['y', 'yes', 'r', 'redo'],
                     tip_msg: "请确认以上信息，没有问题请输入 y(yes) 继续\n 重新输入 r(redo)\n 请输入: ")
      when 'y', 'yes'
        return user
      when 'r', 'redo'
        return init_user
      end
    end

    def get_input_message
      options = {}
      puts_warning "\n请输入以下基本信息用于抓取:"
      options[:first_name] = get_input(tip_msg: '请输入您的贵姓：').strip
      options[:lock_word]  = get_input(allow_empty: true, tip_msg: '想要名字中包含的字(没有请直接回车)：').strip
      options[:sex]        = get_input(allows: ['男', '女'], tip_msg: '性别：').strip
      options[:birthday]   = get_input(tip_msg: '出生时间(eg: 2017-07-24 10:10)：').strip
      options[:province]   = get_input(tip_msg: '省份(eg: 四川)：').strip
      options[:city]       = get_input(tip_msg: '城市(eg: 成都)：').strip
      options[:name_size]  = get_input(allows: (2..5).to_a, tip_msg: '名字长度(eg: 3)：').strip
      options
    end
  end
end
