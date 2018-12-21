#!/usr/bin/env bash


_remoteAction=$1
_FOLDER_NAME=${PWD##*/}
_PARENT_NAME="$(basename "$(dirname "$PWD")")"


if [[ $_remoteAction = 'd' ]]
then
    echo DEVELOPING
fi


if [[ $_remoteAction = 'module' ]]
then
    # Phone Billing - 1812051158
    # https://github.com/angular/angular-cli/wiki/generate-module
    ng generate module --spec=false --flat=true $2
fi

if [[ $_remoteAction = 'page' ]]
then
    _FOLDER_NAME=${PWD##*/}
    _pageModule=$_FOLDER_NAME
    _pageName="$_FOLDER_NAME"Page
    _pageAction="$_pageName"Actions

    ng generate module --spec=false --flat=true $_pageModule
    # https://github.com/angular/angular-cli/wiki/generate-component
    ng generate component $_pageName --inline-style --spec=false --flat=true --export=true

    # Actions
#    ng generate class $_pageAction --spec=false

fi



if [[ $_remoteAction = 'widget' ]]
then
    # Phone Billing - 1812051158
    # https://github.com/angular/angular-cli/wiki/generate-component
    # TODO:
    # component
    # bus
    _widgetName="$_PARENT_NAME"-"$_FOLDER_NAME"
    _widgetBus="$_widgetName"-Bus
    _widgetSetup="$_widgetName"-Setup
    _widgetSelector=cs-$_widgetName

    ng generate component $_widgetName --inline-style --spec=false --flat --export --prefix=cs
    ng generate class $_widgetBus --spec=false

    ng generate class $_widgetSetup --spec=false
fi






if [[ $_remoteAction = 'bus' ]]
then

    ng generate class "$_FOLDER_NAME"-class --spec=false
    ng generate class "$_FOLDER_NAME"-properties --spec=false
    ng generate class "$_FOLDER_NAME"-load --spec=false
    ng generate class "$_FOLDER_NAME"-setup --spec=false

fi