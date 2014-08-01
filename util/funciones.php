<?php


function generarStringAleatorio($length)
{
    $caracteres = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    $string = substr(str_shuffle($caracteres), 0, $length);

    return $string;
}