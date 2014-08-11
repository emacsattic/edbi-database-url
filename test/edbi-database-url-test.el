;;; edbi-database-url-test.el --- edbi-database-url test suite

;;; Commentary:

;;; Code:

(require 'ert)
(require 'edbi-database-url)

;;; Read settings.

(ert-deftest test-edbi-database-url-read-url ()
  (let ((process-environment
         '("DATABASE_URL=postgres://user:password@host:port/name")))
    (should (equal "postgres://user:password@host:port/name"
                   (edbi-database-url-read-url)))))

(ert-deftest test-edbi-database-url-read-url-error ()
  (should-error (edbi-database-url-read-url)))

(ert-deftest test-edbi-database-url-read-url-error-message ()
  (should (equal "Unspecified DATABASE_URL environment variable"
                 (condition-case err
                     (edbi-database-url-read-url)
                   (error (error-message-string err))))))

(provide 'edbi-django-test)

;;; edbi-database-url-test.el ends here
