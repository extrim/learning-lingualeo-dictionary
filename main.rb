require 'libnotify'
require 'nokogiri'
root_dir = ::File.dirname(__FILE__)

f = File.open("#{root_dir}/print.html")
dictionary = Nokogiri::HTML(f)
f.close


rows = dictionary.xpath('//table/tbody/tr')
details = rows.collect do |row|
  detail = {}
  [
    [:id, 'td[1]/text()'],
    [:word, 'td[2]/b/text()'],
    [:transcription, 'td[3]/text()'],
    [:translation, 'td[4]/text()']
  ].each do |name, xpath|
    detail[name] = row.at_xpath(xpath).to_s.strip
  end
  detail
end

word = details.sample

Libnotify.show :summary => word[:word], :body => "#{word[:transcription]} \n #{word[:translation]}"
