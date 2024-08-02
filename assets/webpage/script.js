var testDiv = document.getElementById("testDiv");
testDiv.addEventListener('click', function f(e) {
    testDiv.setAttribute('style', 'background:red;')
    console.log("style changed");
})

function showData(data) {
     const contentDiv = document.getElementById('content');
     contentDiv.innerHTML = '<p>Received Data: ' + data + '</p>';
}