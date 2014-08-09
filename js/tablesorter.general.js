/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


$(document).ready(function() {

    $('#tmant').tablesorter();

    //variables necesarias
    var show_per_page = 10;
    var number_of_items = $('#tmant').children('tbody').children().size();
    var number_of_pages = Math.ceil(number_of_items / show_per_page);
    var last_page = number_of_pages - 1;
    var current_link = 0;

    //hidden values
    $('#current_page').val(0);
    $('#show_per_page').val(show_per_page);

    var navigation_html = '<ul class="pagination"><li><a title="Primera Pagina" id="prv_lnk" href="javascript:go_to_page(0);">&laquo;</a></li>';
    while (number_of_pages > current_link) {
        navigation_html += '<li><a id="pg_lnk" href="javascript:go_to_page(' + current_link + ')" longdesc="' + current_link + '">' + (current_link + 1) + '</a></li>';
        current_link++;
    }
    navigation_html += '<li><a title="Ultima Pagina" id="nxt_lnk" href="javascript:go_to_page(' + last_page + ');">&raquo;</a></li></ul>';

    //Crea el pager
    $('#page_navigation').html(navigation_html);

    //Oculta todos los elementos dentro del div y muestra los de la primera pagina
    $('#tmant').children('tbody').children().addClass("hideDataFromTsorter");
    $('#tmant').children('tbody').children().slice(0, show_per_page).removeClass("hideDataFromTsorter");
    $('#page_navigation #pg_lnk:first').attr('id', 'active_page');
});

function go_to_page(page_num) {

    //Obtiene el numero de elementos por pagina
    var show_per_page = parseInt($('#show_per_page').val());

    //Desde que numero hasta que numero de elemento se mostrara
    start_from = page_num * show_per_page;
    end_on = start_from + show_per_page;

    //Oculta todos los elementos del div y muestra solo los del rango pedido
    $('#tmant').children('tbody').children().addClass("hideDataFromTsorter").slice(start_from, end_on).removeClass("hideDataFromTsorter");

    /*get the page link that has longdesc attribute of the current page and add active_page class to it
     and remove that class from previously active page link*/
    $('#pg_lnk[longdesc=' + page_num + ']').attr('id', 'active_page').siblings('#active_page').attr('id', 'active_page');

    //Actualiza la pagina activa
    $('#current_page').val(page_num);
}	
