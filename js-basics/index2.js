//d3.select('body')
  //          .append('p')
    //        .style('color', 'blue') // property + value 
      //      .text('Hello world'); // this will select paragraph and change text 
        

// https://www.youtube.com/watch?v=4haBbPEClP4&list=PL6il2r9i3BqH9PmbOf5wA5E1wOG3FT22p&index=4

var canvas = d3.select('body')   // assign a variable 
    .append('svg')
    .attr('width', 500)
    .attr('height', 500);

var circle = canvas.append('circle')
                .attr('cx', 250)
                .attr('cy', 250)
                .attr('r', 50)
                .attr('fill', 'red');

var rect = canvas.append('rect')
                .attr('width', 100)
                .attr('height', 50);

var line = canvas.append('line')
                .attr('x1', 0)     // position of first point (x1, y1)
                .attr('y2', 100)
                .attr('x2', 400)
                .attr('y2', 400)
                .attr('stroke', 'green')
                .attr('stroke-width', 10);