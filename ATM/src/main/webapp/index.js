function updateDateTime() {
    const dateTimeElement = document.getElementById('dateTime');
    const now = new Date();

    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const day = days[now.getDay()];

    const date = now.getDate();
    const month = now.getMonth() + 1;
    const year = now.getFullYear();

    const hours = now.getHours();
    const minutes = now.getMinutes();

    const dateInfo = `${day}, ${date}/${month}/${year}`;
    const timeInfo = `${hours}:${minutes < 10 ? '0' + minutes : minutes}`;

    dateTimeElement.innerHTML = `${dateInfo}<br>${timeInfo}`;
}
function a(){
    window.location.href = 'account.html';
}

setInterval(updateDateTime, 1000);
updateDateTime();
