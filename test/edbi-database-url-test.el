;;; edbi-database-url-test.el --- edbi-database-url test suite

;;; Commentary:

;;; Code:

(require 'ert)
(require 'edbi-database-url)

(defun mock-read-string (&rest ignored)
  "Mock `read-string' variant IGNORED any args."
  "postgres://user:password@host:5678/name")

(defalias 'read-string 'mock-read-string)

;;; Read settings.

(ert-deftest test-edbi-database-url-read-url ()
  (let ((process-environment
         '("DATABASE_URL=postgres://user:password@host:5678/name")))
    (should (equal "postgres://user:password@host:5678/name"
                   (edbi-database-url-read-url)))))

(ert-deftest test-edbi-database-url-read-url-error ()
  (should-error (edbi-database-url-read-url)))

(ert-deftest test-edbi-database-url-read-url-error-message ()
  (should (equal "Unspecified DATABASE_URL environment variable"
                 (condition-case err
                     (edbi-database-url-read-url)
                   (error (error-message-string err))))))

(ert-deftest test-edbi-database-url-read-url-C-u ()
  (should (equal "postgres://user:password@host:5678/name"
                 (let ((current-prefix-arg '(4)))
                   (edbi-database-url-read-url)))))

(ert-deftest test-edbi-database-url-read-url-region-active ()
  (with-temp-buffer
    (insert "sqlite://user:password@host:5678/name")
    (transient-mark-mode 1)
    (mark-whole-buffer)
    (should (equal "sqlite://user:password@host:5678/name"
                   (let ((current-prefix-arg '(4)))
                     (edbi-database-url-read-url))))))

;;; Parse url.

(ert-deftest test-edbi-database-url-parse-url ()
  (should (equal "localhost"
                 (url-host
                  (edbi-database-url-parse-url
                   "sqlite://user:password@localhost:5678/name")))))

;;; Generate uri.

(ert-deftest test-edbi-database-url-generate-uri ()
  (should (equal "dbi:Pg:dbname=test;host=localhost;port=5678"
                 (edbi-database-url-generate-uri
                  (edbi-database-url-parse-url
                   "postgres://user:password@localhost:5678/test")))))

;;; Data source.

(ert-deftest test-edbi-database-url-data-source ()
  (should (equal "password"
                 (caddr
                  (edbi-database-url-data-source
                   (edbi-database-url-parse-url
                    "postgres://user:password@localhost:5678/test"))))))

(provide 'edbi-django-test)

;;; edbi-database-url-test.el ends here
