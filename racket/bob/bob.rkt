#lang racket

(provide response-for)

(define (yelling? phrase)
  (regexp-match? #rx"^[A-Z]+$" (string-replace phrase #rx"[^A-Za-z]" "")))

(define (asking? phrase) (regexp-match? #px"[[:alnum:]]+\\?$" phrase))

(define (uhhh? phrase) (equal? (string-replace phrase " " "") ""))

(define (response-for phrase)
  (cond
    [(uhhh? phrase) "Fine. Be that way!"]
    [(yelling? phrase) "Whoa, chill out!"]
    [(asking? phrase) "Sure."]
    [else "Whatever."]))


