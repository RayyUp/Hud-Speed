window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === 'updateHUD') {
       
        document.getElementById('speed').innerText = data.speed.toString().padStart(3, '0'); 
        
        document.getElementById('fuel').innerText = data.fuel.toString().padStart(2, '0');
     
        document.getElementById('mileage').innerText = data.mileage.toFixed(1);
    }

    if (data.action === 'toggleHUD') {
        const hud = document.getElementById('hud');
        hud.style.display = data.state ? 'flex' : 'none';
    }
});
