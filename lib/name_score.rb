#encoding: utf-8
class NameScore
  extend Console
  class << self
    def run
      user  = UserConfig.current
      words = WordLibary.current_words
      puts_warning "正在进行抓取，详细内容请在该目录下执行 tail -f log/name_result.log"
      words.each_slice(5) do |arr|
        birthday = Time.parse user.birthday
        page = agent.get("http://life.httpcn.com/xingming.asp")
        form = page.form_with(name: 'theform')
        form.xing = user.first_name
        form.radiobutton(name: 'data_type').check
        form.year = birthday.year
        form.month = birthday.month
        form.day   = birthday.day
        form.hour  = birthday.hour
        form.minute = birthday.min
        form.pid    = user.province
        form.cid    = user.city
        form.sex    = user.sex == "女" ? '0' : '1'
        form.radiobutton(name: 'wxxy').check
        arr.each do |w|
          form.ming = w
          result = form.submit
          name = user.first_name + w
          wuge = result.search("div.chaxun_b").search('font').search('b').first.try(:text)
          bazi = result.search("div.chaxun_b").search('font').search('b').last.try(:text)
          total = wuge.to_f + bazi.to_f
          if total > 180
            puts_result "姓名: #{name} 五格: #{wuge} 八字: #{bazi}  总计: #{total}"
          end
        end
      end
    end

    def agent
      @client = Mechanize.new
    end
  end
end
