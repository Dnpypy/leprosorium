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

# before выполняется перед выполнением любого запроса метод init_db
before do
  # init_db <--- тут инициализируется переменная @db
	init_db
end

=begin
Лучшее место, чтобы создавать таблицы метод configure
метод configure срабатывает, когда происходит инициализация приложения
инициализация приложения происходит, когда сохраняем файл
и когда мы обновляем страницу
=end

configure do
	# init_db <--- тут инициализируется переменная @db
	init_db

	# CREATE TABLE IF NOT EXISTS
	# Условия, чтобы таблица каждый раз не пересоздавалась
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"created_date" DATE,
		"content" TEXT
		)'
end

get '/' do
	@title = "Leprosorium"
	# Выбираем список постов из БД, Desc впорядке убывания
	# Глобальная переменная @results, буду к ней обращаться в представлении

	# Пока файл не пустой? Отображаем содержимое, иначе пустое
	unless "leprosorium.db".empty?
		@results = @db.execute 'SELECT * FROM Posts ORDER BY ID Desc'
	end

	erb :index

end


# Обработчик get-запроса /new
# (браузер получает страницу с сервера)
get "/new" do
	erb :new
end


# Обработчик post-запроса /new
# (браузер отправляет данные на сервер)
post "/new" do
	# Получаем переменную из post запроса
	content = params[:content]

	# # первый способ <= покрывает все случаи, хотя отрицание тут никогда не будет
	# if content.length <= 0
	# 	@error = "Введите текст"
	#
	# 	# Возвращаем нашу страницу заново
	# 	erb :new
	# end

	# второй способ проверка, strip обрезает все лишнее, empty?(пустое ли?)
	if content.strip.empty?
		@error = "Введите текст"

		# Возвращаем нашу страницу заново
		erb :new
	end

=begin
	метод execute принимает два параметра
	? - если мы хотим здесь чтото указать то указывает это в массиве []
  Сохранение данных в БД
=end

	@db.execute 'insert into Posts
								(content, created_date)
								 values (?, datetime())', [content]

	# перенаправление(redirect ) на главную страницу 
	erb "You typed #{content}"
end

get "/contacts" do
	# делаю заглушку для /contacts
	erb "Контакты"
end
