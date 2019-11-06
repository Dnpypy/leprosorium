#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

=begin
Чтобы глобальную переменную
можно было использовать во всех запросах
используем метод before(выполняется перед выполнением любого запроса)
=end

# метод init_db буду использовать и в before и в configure
def init_db
	# Библиотека SQLite3:: Класс Database
	# . метод new "принимает параметр имя нашей базы данных"
	@db = SQLite3::Database.new "leprosorium.db"
	# Результаты возвращаются в виде хэша, а не массива
	@db.results_as_hash = true
end

before do

end

get '/' do
	@title = "Leprosorium"
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get "/new" do
	# добавляем загулшку для /new
	erb :new
end

post "/new" do
	content = params[:content]

	erb "You typed #{content}"
end
