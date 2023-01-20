require 'net/http'
require 'rexml/document'

def get_rate
  url = 'http://www.cbr.ru/scripts/XML_daily.asp'.freeze
  response = Net::HTTP.get_response(URI.parse(url))
  doc = REXML::Document.new(response.body)

  doc.root.elements['//Valute[@ID="R01235"]/Value'].text.to_f
end

def briefcase(dollars, rubles, rate)
  dollars_in_rubles = rubles / rate
  ((dollars_in_rubles - dollars) / 2).round(2)
end

begin
  rate = get_rate
  puts "Текущий курс доллара - #{rate} руб."
rescue SocketError
  puts "Не удалось подключиться к серверу. Какой сейчас курс доллара:"
  rate = gets.to_f
end

puts "Сколько у вас рублей?"
rubles = gets.to_f

puts "Сколько у вас долларов?"
dollars = gets.to_f

dif = briefcase(dollars, rubles, rate)
if dif > 0
  puts "Вам надо купить #{dif} долларов"
elsif dif < 0
  puts "Вам надо продать #{dif.abs} долларов"
else
  puts "Ваш портфель сбалансирован!"
end
