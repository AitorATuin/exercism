#lang racket

(provide word-count)

(define (word-count sentence)
  (make-hash (map
              (λ (xs) (cons (car xs) (length xs)))
              (group-by (lambda (x) x) (string-split sentence)))))

