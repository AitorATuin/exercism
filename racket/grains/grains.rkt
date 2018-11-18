#lang racket

(provide square total)

;; square n -> 2^n
(define (square n) (expt 2 (sub1 n)))

;; total -> 2^65 - 1
(define (total) (sub1 (square 65)))
