#lang racket

(provide (contract-out
          [etl (-> (hash/c positive? list?) (hash/c string? positive?))]))

(define (etl input)
  (let ([h1 (map (λ (xs)
                   (map (λ (x) (cons (string-downcase x) (car xs)))
                        (cdr xs)))
                 (hash->list input))])
    (apply hash (flatten h1))))
