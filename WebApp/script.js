async function addPost() {
    const name = document.querySelector('#name').value;
    const content = document.querySelector('#content').value;

    console.log(name);
    console.log(content);

    if(name.trim() === '' || content.trim() == '') {
        document.querySelector('#validate').style.display = 'block'
        return; 
    } else {
        document.querySelector('#validate').style.display = 'none';
    }

    const response = await fetch('http://localhost:8080/article', 
        {
            method: 'POST',
            headers: {'Content-type':'application/json'},
            body: JSON.stringify({"name":name, "content":content})
        }
    );
    
    document.querySelector('#name').value = '';
    document.querySelector('#content').value = '';
}

async function showPost() {
    const response = await fetch('http://localhost:8080/article');
    const posts = await response.json();
    const postsReversed = posts.reverse();
    console.log(postsReversed);
    document.querySelector('#posts').innerHTML = '';
    for(const post of postsReversed) {
        // const element = array[index];
        document.querySelector('#posts').innerHTML += 
        `
            <div class="card text-center" style="margin: 25px;">
                    <div class="card-header">
                        ${post.name}
                    </div>
                    <div class="card-body"> 
                        <p class="card-text">${post.content}</p>
                    </div>
                    <div class="card-footer text-body-secondary">
                        ${new Date(post.date).toDateString()}
                    </div>
            </div>
        `
    }
}

addEventListener("load", (event) => {
    showPost();
})