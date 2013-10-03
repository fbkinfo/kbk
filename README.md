Код для борьбы с коррупцией (КБК)
===

[![Build Status](https://api.travis-ci.org/fbkinfo/kbk.png)](https://magnum.travis-ci.com/evilmartians/kbk)
[![Code Climate](https://codeclimate.com/github/fbkinfo/kbk.png)](https://codeclimate.com/github/fbkinfo/kbk)

## Установка

1. Убедиться, что установлен psql >= 9.1
2. Выполнить `bundle install`
3. Скопировать `config/database.yml.sample` без `.sample` и заполнить реальными данными для доступа к БД
4. Инициировать базу:
    ```ruby
    rake db:create
    rake db:migrate
    rake db:seed
    ```

5. Запустить сервер: rails s

## Прогон тестов

Команда для запуска тестов: `bundle exec rspec`.
Перед запуском важно убедиться в корректности секции test в `config/database.yml`.

*Важно: для конвертации PDF надо иметь последнюю версию ImageMagick*

http://stackoverflow.com/questions/17072683/rmagick-not-opening-multi-page-pdfs-correctly

## Выкладка

Для выкладки (deploy), у вас должен быть доступ к репозиторию kbk-config.

1. Добавьте этот репозиторий как сабмодуль: `git submodule add -f git@github.com:evilmartians/kbk-config.git deploy`
2. Выполните `rake app:bootstrap_deploy` для линковки конфигов

После этого можно использовать команды `cap production/staging deploy`
