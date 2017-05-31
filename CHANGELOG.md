# Change Log

An [unreleased] version is not available on rubygems and is subject to changes and must not be considered final. Elements of unreleased list may be edited or removed at any time.

## [0.5.1] 2017-04-16

- [Added] Support to log HTTP requests and responses.
- [Added] Rename keys with better names while supporting old methods
- [Fix] Avoid circular require warnings when running tests

## [0.5.0] 2016-11-26

- [Added] Add search object and filtering api
- [Added] Add support for document uploading
- [Added] Add link API
- [Added] Add tests for attributes
- [Added] Add charge method on customer
- [Added] Add pagination on list

## [0.4.0] 2016-06-01

- [Added] Add charge reversal method (@zentetsukenz)
- [Updated] Update Rest-Client version (@zacksiri)

## [0.3.0] 2016-02-18

- [Added] Add Events API

## [0.2.1] 2015-12-01

- [Added] Add fetching options to customer cards (6ef31e6)

## [0.2.0] 2015-11-13

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
