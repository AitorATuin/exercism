#lang racket

(provide to-roman)

(define ((digit-to-roman symbols) d)
  (cond
    [(< d 4) (format "~a" (make-string d (first symbols)))]
    [(= d 4) (format "~a~a" (first symbols) (second symbols))]
    [(= d 5) (format "~a" (second symbols))]
    [(< d 9) (format "~a~a" (second symbols) (make-string (- d 5) (first symbols)))]
    [(= d 9) (format "~a~a" (first symbols) (third symbols))]
    [(error "Wrong number")]))

(define hooks (hash
               1 (digit-to-roman '(#\I #\V #\X))
               2 (digit-to-roman '(#\X #\L #\C))
               3 (digit-to-roman '(#\C #\D #\M))
               4 (digit-to-roman '(#\M #\M #\M))))

(define (number-to-roman number [i 1] [result ""])
  (cond
    [(= number 0) result]
    [(<= i 4)
     (let*-values ([(next-number digit) (quotient/remainder number 10)]
                   [(hook) (hash-ref hooks i)])
       (number-to-roman next-number (add1 i) (string-append (hook digit) result)))]
    [(error "Wrong number")]))

(define (to-roman number) (number-to-roman number))
