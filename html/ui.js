$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var data = event.data;
        if(data.health >165){
            $(".sange").hide()
        }
        else if (data.health <= 165 && data.health > 150){
            $(".sange").show();
            $(".sange").css( "opacity", .1);
        }
        else if(data.health <= 150 && data.health > 130){
            $(".sange").show();
            $(".sange").css( "opacity", .35);
        }
        else if(data.health <= 130 && data.health > 115){
            $(".sange").show();
            $(".sange").css( "opacity", .7);
        }
        else if(data.health <= 115){
            $(".sange").show();
            $(".sange").css( "opacity", 1.0);
        }
    }
)})