function show_hud() { $("body").fadeIn(300); } 
function hide_hud() { $("body").fadeOut(300); } 
function show_speedometer(status) { status ? $(".speedometer").fadeIn(300) && $(".speedometer .speed-items").animate({ opacity: 1 }, 300) : $(".speedometer").fadeOut(300) && $(".speedometer .speed-items").animate({ opacity: 0 }, 300); } 
function health(num) { $(".health .fill").attr("style", "width:" + num + "%"); } 
function food(num) { $(".food .fill").attr("style", "width:" + num + "%"); } 
function water(num) { $(".water .fill").attr("style", "width:" + num + "%"); } 
function armour(num) { $(".armour .fill").attr("style", "width:" + num + "%"); num <= 0 ? $(".armour").hide() : $(".armour").show(); } 
function speed(num) { $({ numberValue: $(".speed p").text() }).animate({ numberValue: num }, { duration: 200, easing: 'swing', step: function() { $(".speed p").text(Math.ceil(this.numberValue)); } }); } 
function engine(num) { $(".engine .fill").attr("style", "height:" + num + "%"); $(".engine p.px").text(num + "%"); } 
function fuel(num) { $(".fuel .fill").attr("style", "height:" + num + "%"); $(".fuel p.px").text(num + "%"); } 
window.addEventListener('message', (event) => { const status = event.data.status; const data = event.data.data; if (status == "info") { health(data.health.toFixed(0)); armour(data.armour.toFixed(0)); food(data.food.toFixed(0)); water(data.water.toFixed(0)); } if (status == "visible") { data ? show_hud() : hide_hud(); } if (status == "speedometer") { if (!data.visible) return show_speedometer(false); show_speedometer(true); const speed_num = data.speed.toFixed(0); const engine_num = data.engine.toFixed(0); const fuel_num = data.fuel.toFixed(0); if (data.mph) $(".speed span").text("mph"); speed(speed_num); engine(engine_num); fuel(fuel_num); if (speed_num <= 1) { $(".speedometer").fadeOut(300); $(".engine").fadeOut(300); $(".fuel").fadeOut(300); } else { $(".speedometer").fadeIn(300); $(".engine").fadeIn(300); $(".fuel").fadeIn(300); } } }); 
window.addEventListener('message', function (event) { if (event.data.action === 'showTalkingImage') { const talkingImage = document.getElementById('talkingImage'); talkingImage.classList.add('show'); } else if (event.data.action === 'hideTalkingImage') { const talkingImage = document.getElementById('talkingImage'); talkingImage.classList.remove('show'); } });
