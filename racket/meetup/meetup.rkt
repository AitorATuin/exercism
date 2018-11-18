#lang racket

(require racket/date)

(provide meetup-day)

(define (list->map xs #:by-index [by-index #t])
  (for/hash ([i (in-naturals 1)] [x xs])
    (if by-index (values i x) (values x i))))

(define week/days '(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))

(define week/days-by-name (list->map week/days #:by-index #f))

(define week/days-by-index (list->map week/days))

(define (year/leap? year)
  (let* ([by-4 (zero? (remainder year 4))]
         [by-100 (zero? (remainder year 100))]
         [by-400 (zero? (remainder year 400)]])
    (or (and by-4 (not by-100)) (and by-4 by-100 by-400)))) 

(define (year/month-days year)
  (let ([leap-year (if (year/leap? year) 1 0)])
    (list 31 (+ 28 leap-year) 31 30 31 30 31 31 30 31 30 31))) 

(define month/descriptions(hash
                           'first (λ (xs) (car xs))
                           'second (λ (xs) (second xs))
                           'third (λ (xs) (third xs))
                           'fourth (λ (xs) (fourth xs))
                           'last (λ (xs) (last xs))
                           'teenth (λ (xs)
                                     (findf
                                      (λ (x) (and
                                              (>= x 13)
                                              (<= x 19)))
                                      xs))))

(define (month/days first wanted n-days-in-month)
  (let ([r0 (+ (modulo (+ (- wanted first) 7) 7) 1)])
    (stream->list (in-range r0 (+ n-days-in-month 1) 7))))

(define (year/first-day year)
  (let* ([leap-years (quotient (- year 2001) 4)]
        [normal-years (- year 2001 leap-years)])
    (+ (modulo (+ (* leap-years 2) normal-years) 7) 1)))

(define (month/first-day year month)
  (let* ([1st-jan (year/first-day year)])
    (modulo
     (+ (for/sum ([d (take (year/month-days year) (- month 1))]) d) 1st-jan)
     7)))

(define (make-date year month day)
  (seconds->date (find-seconds 0 0 0 day month year #f) #f))

(define (meetup-day year month day desc)
  (let* ([desc-hook (hash-ref month/descriptions desc)]
         [wanted-day (hash-ref week/days-by-name day)]
         [1st-day (month/first-day year month)]
         [days (month/days 1st-day wanted-day (list-ref (year/month-days year) (- month 1)))]
         [day (desc-hook days)])
    (make-date year month day)))
