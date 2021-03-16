document.addEventListener('turbolinks:load', () => {
    document.querySelector('.answers').addEventListener('click', (e) => {
        if (!e.target.matches('.edit-answer-link'))
            return

        e.preventDefault()
        let answerId = e.target.dataset.answerId
        document.querySelector('form#edit-answer-' + answerId).classList.remove('d-none')
    })
})