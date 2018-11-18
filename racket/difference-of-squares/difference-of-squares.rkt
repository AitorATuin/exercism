#lang racket

(provide sum-of-squares square-of-sum difference)

(define (sum-of-n pre-f post-f n)
  (pre-f (for/sum ([i (in-naturals 1)]
                  #:final (= i n))
          (post-f i))))

(define (expt-2 x) (expt x 2))

(define (square-of-sum n) (sum-of-n expt-2 identity n))

(define (sum-of-squares n) (sum-of-n identity expt-2 n))

(define (difference n) (- (square-of-sum n) (sum-of-squares n)))
