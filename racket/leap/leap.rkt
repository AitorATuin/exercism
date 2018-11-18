#lang racket

(provide leap-year?)

(define ((div-by year) n) (zero? (remainder year n)))

(define (leap-year? year)
  (let* ([div-year-by (div-by year)]
        [div-by-4 (div-year-by 4)]
        [div-by-100 (div-year-by 100)]
        [div-by-400 (div-year-by 400)])
    (or (and div-by-4 (not div-by-100))
        (and div-by-4 div-by-100 div-by-400))))
