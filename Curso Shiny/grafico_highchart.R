library(highcharter)


h <- highchart() |>
     hc_chart(list(type = 'column')) |>
   hc_series(list(name = 'John', data = list(5, 3, 4, 7, 2), stack = 'male'))|>
  hc_series(list(name = 'Joe', data = list(3, 4, 4, 2, 5), stack = 'male')) |>
  hc_series(list(name = 'Jane', data = list(2, 5, 6, 2, 1), stack = 'female')) |>
  hc_series(list(name = 'Janet', data = list(3, 0, 4, 4, 3), stack = 'female')) 
  
  
     hc_title(text = 'Total fruit consumption, grouped by gender') |>
     hc_yAxis(categories = c('Apples', 'Oranges', 'Pears', 'Grapes', 'Bananas')) |>
     hc_yAxis(allowDecimals = FALSE, min = 0, title = list(text = 'Number of fruits')) |>
     hc_tooltip(formatter = JS("function(){return '<b>' + this.x + '</b><br/>' +
         this.series.name + ': ' + this.y + '<br/>' +
         'Total: ' + this.point.stackTotal;})")) |>
     hc_plotOptions(column = list(stacking = 'normal')) |>
     
               

  
  
  

