#lang racket/base

(provide sum-of-squares square-of-sum difference)

(define (sum-of-n pre-f post-f n)
  (pre-f (for/sum ([i (in-range 1 (add1 n))])
           (post-f i))))

(define (square x) (expt x 2))

(define (id x) x)

(define (square-of-sum n) (sum-of-n square id n))

(define (sum-of-squares n) (sum-of-n id square n))

(define (difference n) (- (square-of-sum n) (sum-of-squares n)))
