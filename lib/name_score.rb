#encoding: utf-8
class NameScore
  extend Console
  class << self
    def run
      user  = UserConfig.current
      words = WordLibary.current_words
      birthday = user.birthday
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
      words.each do |w|
        form.ming = w
        result = form.submit
        wuge = result.search("div.chaxun_b").search('font').search('b').first.text
        bazi = result.search("div.chaxun_b").search('font').search('b').last.text
        puts_result "#{user.first_name + w}   五格: #{wuge}    八字: #{bazi}"
      end
    end

    def agent
      @client = Mechanize.new
    end
  end
end
