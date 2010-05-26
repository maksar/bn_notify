require 'rubygems'
errors = []
%w(mechanize hpricot growl iconv).each do |gem|
  begin
    require gem 
  rescue LoadError
    errors << gem
  end
end
  
puts errors

class Symbol
  def to_proc
    sym = self
    lambda{|obj| obj.send sym}
  end
end

form = Mechanize.new.get('http://users.idom.by/').forms.first
form.login  = ARGV[0]
form.passwd = ARGV[1]

data = Hpricot(form.click_button.body).search('span .info').map(&:html)

balance = data[3].split(',').first.sub(' ', '').to_i
name = data[0].split(',').first.sub(' ', '')
tarif = data[2].split(',').first.sub(' ', '')

message = ''
message << 'Счет: ' + Iconv.iconv('utf-8', 'cp1251', name).join() + '
'
message << Iconv.iconv('utf-8', 'cp1251', tarif).join() + '
'

message << [ "Баланс: #{(balance - (12 * 1000)) / 3300} дня!"].join()

Growl.notify message
