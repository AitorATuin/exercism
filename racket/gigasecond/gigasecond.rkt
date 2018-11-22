#lang racket/base

(provide add-gigasecond)

(require racket/date)

(define ((add-to-date const) date)
  (seconds->date (+ (date->seconds date) const)))

(define add-gigasecond (add-to-date (expt 10 9)))


