# Change Log

An [unreleased] version is not available on rubygems and is subject to changes and must not be considered final. Elements of unreleased list may be edited or removed at any time.

## [unreleased]

- [Added] Add Omise-Version header to request.
- [Fixed] Fix auto expanding attribute does not play well with expand=true.
- [Fixed] Fix bank accounts were typecasted as OmiseObject instead of being
          typecasted as BankAccount.

## [0.1.5] 2015-07-29

- [Added] Add json dependency in the gemspec.
- [Added] New DigiCert CA certificates.

## [0.1.1] 2015-01-19

- [Fixed] Fix a charge object is not able to retrieve its transaction object.

## [0.1.0] 2015-01-19

- [Added] Add support for the Refund API.
- [Added] Add a test suite that can be run locally without the need for a    
          network connection or to set Omise keys.
- [Added] Add a list method to retrieve a list of objects.
- [Changed] Move typecast and load_response methods into a Util module.
- [Removed] Remove the ability to retrieve a list by calling retrieve without
            arguments.

## [0.0.1] - 2014-11-18

- Initial version.
