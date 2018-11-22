#lang racket/base

(provide classify)

(define (aliquot-sum n)
  (define (sum n)
    (for/sum ([i (in-range 2 (add1 (floor (sqrt n))))]
              #:when (zero? (modulo n i)))
      (if (= (/ n i) i) i (+ i (/ n i)))))
  (cond
    [(= n 1) 0]
    [else (add1 (sum n))])) 

(define (classify n)
  (let ([sum (aliquot-sum n)])
    (cond
      [(= sum n) 'perfect]
      [(< sum n) 'deficient]
      [else 'abundant])))


