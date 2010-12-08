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

data = Hpricot(form.click_button.body).search('table')

balance = data.search('tr')[3].search('td').html.gsub(/[^0-9,]/, "").to_i
name = data.search('tr')[1].search('td').html
tarif = data.search('tr')[2].search('td').html

message = ''
message << Iconv.iconv('utf-8', 'cp1251', name).join() + '
'
message << Iconv.iconv('utf-8', 'cp1251', tarif).join() + '
'

message << [ "Баланс: #{(balance - (12 * 1000)) / 3300} дня!"].join()

Growl.notify message
