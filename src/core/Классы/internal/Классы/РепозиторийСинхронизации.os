#Использовать logos

Перем Наименование;
Перем ПутьКХранилищу;
Перем ПутьКРабочемуКаталогу;
Перем ПутьИсполняемомуФайлуГит;
Перем ПутьКВременномуКаталогу;
Перем ВерсияПлатформы;
Перем ДоменПочтыПоУмолчанию;
Перем ПользовательХранилища;
Перем ПарольПользователяХранилища;
Перем УровеньЛогаСинхронизации;
Перем КоличествоЦикловОжиданияЛицензии;
Перем ИмяРасширения;
Перем ИндексПодписчиков;
Перем ПараметрыПодписчиков;

Перем МенеджерСинхронизации;
Перем КаталогПлагинов;

Перем Лог;

// Обертка над МенеджерСинхронизации.Синхронизировать
//
//   СтрокаСоединенияИБ - Строка, необязательный, формат: /SServerName\BaseName или /F<Путь к ИБ>
//   ПользовательИБ - Строка, необязательный
//   ПарольПользователяИБ - Строка, необязательный
Процедура Синхронизировать(Знач СтрокаСоединенияИБ = "",
							Знач ПользовательИБ = "",
							Знач ПарольПользователяИБ = "") Экспорт

	Лог.Информация("=================================");
	Лог.Информация("Начало синхронизации с хранилищем");
	Лог.Информация("Наименование: <%1>", Наименование);
	Лог.Информация("Путь к хранилищу: <%1>", ПутьКХранилищу);
	Лог.Информация("Путь к рабочей копии: <%1>", ПутьКРабочемуКаталогу);

	ПроверитьВозможностьСинхронизации();

	МенеджерСинхронизации = ПолучитьМенеджерСинхронизации(СтрокаСоединенияИБ, ПользовательИБ, ПарольПользователяИБ);

	Если МенеджерСинхронизации.ТребуетсяСинхронизироватьХранилищеСГит(ПутьКРабочемуКаталогу, ПутьКХранилищу) Тогда

		МенеджерСинхронизации.Синхронизировать(ПутьКРабочемуКаталогу, ПутьКХранилищу,
												СтрокаСоединенияИБ, ПользовательИБ, ПарольПользователяИБ);

		Лог.Информация("Завершена синхронизации с хранилищем");
		Лог.Информация("Наименование: <%1>", Наименование);
		Лог.Информация("Путь к хранилищу: <%1>", ПутьКХранилищу);
		Лог.Информация("Путь к рабочей копии: <%1>", ПутьКРабочемуКаталогу);
	
	Иначе
		Лог.Информация("--> Синхронизация не требуется <--");	
	КонецЕсли;
	Лог.Информация("=================================");

КонецПроцедуры

Процедура ПроверитьВозможностьСинхронизации()
	// TODO: Написать проверку какую? )
КонецПроцедуры

Функция ПолучитьМенеджерСинхронизации(Знач СтрокаСоединенияИБ = "",
										Знач ПользовательИБ = "",
										Знач ПарольПользователяИБ = "")
	
	МенеджерСинхронизации = Новый МенеджерСинхронизации();
	МенеджерСинхронизации.ВерсияПлатформы(ВерсияПлатформы)
						.ДоменПочтыПоУмолчанию(ДоменПочтыПоУмолчанию)
						.ИсполняемыйФайлГит(ПутьИсполняемомуФайлуГит)
						.ПодпискиНаСобытия(ИндексПодписчиков)
						.ПараметрыПодписокНаСобытия(ПараметрыПодписчиков)
						.ЦикловОжиданияЛицензии(КоличествоЦикловОжиданияЛицензии)
						.РежимУдаленияВременныхФайлов(Истина)
						.АвторизацияВХранилищеКонфигурации(ПользовательХранилища, ПарольПользователяХранилища);

	Если ЗначениеЗаполнено(СтрокаСоединенияИБ) Тогда
		МенеджерСинхронизации.УстановитьКонтекст(СтрокаСоединенияИБ, ПользовательИБ, ПарольПользователяИБ);
	КонецЕсли;

	Если ЗначениеЗаполнено(ИмяРасширения) Тогда
		МенеджерСинхронизации.ИмяРасширения(ИмяРасширения);
	КонецЕсли;

	Возврат МенеджерСинхронизации;

КонецФункции

// Устанавливает путь к каталогу плагинов
//
// Параметры:
//   НовыйКаталогПлагинов - Строка - путь к каталогу плагинов
//
// Возвращаемое значение:
//   Объект.МенеджерСинхронизации - ссылка на текущий объект класса <МенеджерСинхронизации>
//
Функция КаталогПлагинов(Знач НовыйКаталогПлагинов) Экспорт
	КаталогПлагинов = НовыйКаталогПлагинов;
	Возврат ЭтотОбъект;
КонецФункции

Процедура ПрочитатьПараметры(Знач ВходящиеПараметры) Экспорт

	Наименование = ВходящиеПараметры.Наименование;
	ПользовательХранилища = ВходящиеПараметры.ПользовательХранилища;
	ПарольПользователяХранилища = ВходящиеПараметры.ПарольПользователяХранилища;
	ВерсияПлатформы = ВходящиеПараметры.ВерсияПлатформы;
	ИмяРасширения = ВходящиеПараметры.ИмяРасширения;
	ПутьКХранилищу = ВходящиеПараметры.ПутьКХранилищу;
	ПутьКРабочемуКаталогу = ВходящиеПараметры.ПутьКРабочемуКаталогу;
	ПутьИсполняемомуФайлуГит = ВходящиеПараметры.ПутьИсполняемомуФайлуГит;
	ПутьКВременномуКаталогу = ВходящиеПараметры.ПутьКВременномуКаталогу;
	ДоменПочтыПоУмолчанию = ВходящиеПараметры.ДоменПочтыПоУмолчанию;
	КоличествоЦикловОжиданияЛицензии = ВходящиеПараметры.КоличествоЦикловОжиданияЛицензии;
		
	ПрочитатьПлагины(ВходящиеПараметры.Плагины);

	ПараметрыПодписчиков = ВходящиеПараметры.НастройкиПлагинов;

КонецПроцедуры

Процедура ПрочитатьПлагины(Знач НастройкаПлагинов)
	
	МенеджерПлагинов = Новый МенеджерПлагинов;
	МенеджерПлагинов.УстановитьКаталогПлагинов(КаталогПлагинов);
	МенеджерПлагинов.ЗагрузитьПлагины();

	МенеджерПлагинов.ВключитьПлагины(НастройкаПлагинов.ВключенныеПлагины);
	МенеджерПлагинов.ВключитьПлагины(НастройкаПлагинов.ДополнительныеПлагины);
	МенеджерПлагинов.ОтключитьПлагины(НастройкаПлагинов.ОтключенныеПлагины);

	ИндексПодписчиков = МенеджерПлагинов.ПолучитьИндексПлагинов();

КонецПроцедуры

Процедура ПриСозданииОбъекта()

	Лог = Логирование.ПолучитьЛог("oscript.lib.gitsync.batch");

КонецПроцедуры
