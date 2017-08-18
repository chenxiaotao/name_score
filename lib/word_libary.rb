#encoding: utf-8
class Array
  def perm(n)
    if size < n || n < 0
    elsif n == 0
      yield([])
    else
      self[1..-1].perm(n - 1) do |x|
        (0...n).each do |i|
          yield(x[0...i] + [first] + x[i..-1])
        end
      end
      self[1..-1].perm(n) do |x|
        yield(x)
      end
    end
  end
end

class WordLibary
  extend Console
  
  class << self
    def current_words
      @words ||= init_libary
    end

    def init_libary
      libary_name = choose_libary

      puts_warning "您选择了 #{libary_name} 字库 正在解析字库..."
      if UserConfig.current.limit_size <= 0
        puts_warning "由于所需字库的字段为0，无需使用字库，放弃解析"
        words = []
      else
        words = analysis_libary(libary_name)
      end

      puts_info "你选择的字库总字数为 #{words.size}"
      puts_info "注意: 字库过大排列组合个数会随名字长度呈指数倍增加"

      case get_input(allows: ['y', 'yes', 'r', 'redo'],
                     tip_msg: "请确认字库是否确认，没有问题请输入 y(yes) 继续\n 重新输入 r(redo)\n 请输入: ")
      when 'y', 'yes'
      when 'r', 'redo'
        return init_libary
      end

      permutation_and_combination(words, UserConfig.current.lock_word)
    end

    def choose_libary
      libaries = get_libary_list
      unless libaries
        puts_error "没有找到任何字库，请将字库拷贝至项目下word_libary目录下"
        exit(0)
      end

      puts "========== 请输入序列号码选择一个字库 =========="
      libaries.each_with_index { |name, index| puts "#{index.succ} #{name}" }

      puts "==============   请选择一个字库   =============="
      input_index = get_input(allows: (1..libaries.size).to_a, tip_msg: "请输入编号(1-#{libaries.size})：",
                              reject_massage: '请输入正确的项目编号：').strip.to_i
      libaries[input_index - 1]
    end

    def get_libary_list
      files = Dir.entries("#{ROOT_PATH}/word_libary").select { |f| !f.start_with?('.') }
      files.uniq.sort {|x, y| y <=> x }
    end

    def analysis_libary(name)
      words = []
      file = File.open("#{ROOT_PATH}/word_libary/#{name}", 'r')
      file.each do |line|
        words += line.scan(/\p{Han}/)
      end
      file.close

      words.uniq
    end

    def permutation_and_combination(words, lock_word)
      puts_warning "正在对字库进行排列组合..."
      all_words    = []
      words.perm(UserConfig.current.limit_size) do |x|
        if lock_word.present?
          all_words += combination_word(x, lock_word)
        else
          all_words << x.join('')
        end
      end
      all_words
    end

    def combination_word(arr, lock_word)
      words = []
      arr_load = arr.dup
      (arr.size + 1).times.each do |index|
        words << arr.insert(index, lock_word).join('')
        arr = arr_load
      end
      words
    end

  end
end
