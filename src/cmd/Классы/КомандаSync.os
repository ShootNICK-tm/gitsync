﻿
Перем Лог;

Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("u storage-user", "", "пользователь хранилища конфигурации")
					.ТСтрока()
					.ВОкружении("GITSYNC_STORAGE_USER")
					.ПоУмолчанию("Администратор");

	Команда.Опция("p storage-pwd", "", "пароль пользователя хранилища конфигурации")
					.ТСтрока()
					.ВОкружении("GITSYNC_STORAGE_PASSWORD GITSYNC_STORAGE_PWD");
	
	Команда.Опция("e ext extension", "", "имя расширения для работы с хранилищем расширения")
					.ТСтрока()
					.ВОкружении("GITSYNC_EXTENSION");
	
	Команда.Опция("d das disable-auto-src", Ложь, "Отключить автопоиск папки src")
					.ВОкружении("GITSYNC_DISABLE_AUTO_SRC");

	Команда.Аргумент("PATH", "", "Путь к хранилищу конфигурации 1С.")
					.ТСтрока()
					.ВОкружении("GITSYNC_STORAGE_PATH");
	Команда.Аргумент("WORKDIR", "", "Каталог исходников внутри локальной копии git-репозитория.")
					.ТСтрока()
					.ВОкружении("GITSYNC_WORKDIR")
					.Обязательный(Ложь)
					.ПоУмолчанию(ТекущийКаталог());

	ПараметрыПриложения.ВыполнитьПодпискуПриРегистрацииКомандыПриложения(Команда);
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	Лог.Информация("Начало выполнение команды <sync>");
	
	ПутьКХранилищу			= Команда.ЗначениеАргумента("PATH");
	КаталогРабочейКопии		= Команда.ЗначениеАргумента("WORKDIR");
	
	ПользовательХранилища		= Команда.ЗначениеОпции("storage-user");
	ПарольПользователяХранилища	= Команда.ЗначениеОпции("storage-pwd");
	ИмяРасширения				= Команда.ЗначениеОпции("extension");

	ПользовательИБ			= Команда.ЗначениеОпции("ib-user");
	ПарольПользователяИБ	= Команда.ЗначениеОпции("ib-pwd");
	СтрокаСоединенияИБ		= Команда.ЗначениеОпции("ib-connection");

	ФайлКаталогРабочейКопии = Новый Файл(КаталогРабочейКопии);
	КаталогРабочейКопии = ФайлКаталогРабочейКопии.ПолноеИмя;

	Лог.Отладка("ПутьКХранилищу = " + ПутьКХранилищу);
	Лог.Отладка("КаталогРабочейКопии = " + КаталогРабочейКопии);

	КаталогИсходников = КаталогРабочейКопии;
	
	АвтодополнениеПути = НЕ Команда.ЗначениеОпции("disable-auto-src");
	Если АвтодополнениеПути Тогда
		МассивФайлов = НайтиФайлы(КаталогРабочейКопии, "src");
		Если МассивФайлов.Количество() > 0  Тогда
			КаталогИсходников = МассивФайлов[0].ПолноеИмя;
		КонецЕсли;
	КонецЕсли;

	ОбщиеПараметры = ПараметрыПриложения.Параметры();
	МенеджерПлагинов = ПараметрыПриложения.МенеджерПлагинов();
	
	ИндексПлагинов = МенеджерПлагинов.ПолучитьИндексПлагинов();

	Распаковщик = Новый МенеджерСинхронизации();
	Распаковщик.ВерсияПлатформы(ОбщиеПараметры.ВерсияПлатформы)
			   .ПутьКПлатформе(ОбщиеПараметры.ПутьКПлатформе)
			   .ДоменПочтыПоУмолчанию(ОбщиеПараметры.ДоменПочты)
			   .ИсполняемыйФайлГит(ОбщиеПараметры.ПутьКГит)
			   .УстановитьКонтекст(СтрокаСоединенияИБ, ПользовательИБ, ПарольПользователяИБ)
			   .ПодпискиНаСобытия(ИндексПлагинов)
			   .ПараметрыПодписокНаСобытия(Команда.ПараметрыКоманды())
			   .УровеньЛога(ПараметрыПриложения.УровеньЛога())
			   .ИмяРасширения(ИмяРасширения)
			   .АвторизацияВХранилищеКонфигурации(ПользовательХранилища, ПарольПользователяХранилища)
			   .РежимУдаленияВременныхФайлов(Истина)
			   .Синхронизировать(КаталогИсходников, ПутьКХранилищу);

	Лог.Информация("Завершено выполнение команды <sync>");
		
КонецПроцедуры

Лог = ПараметрыПриложения.Лог();