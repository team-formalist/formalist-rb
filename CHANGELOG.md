# 0.7.0 / 2022-04-07

### Added

- Add support a field with an arbitrary list of forms. Supporting updates in formalist-standard-react@^4.2.0
- Add namespace and paths options to embedded form renderer
- Support dry-schema/dry-validation 1.0

# 0.6.0 / 2020-05-06

### Changed

- Removed dry-types dependency from core gem

# 0.5.4 / 2018-11-28

### Fixed

- Fixed the rendering of validation errors when validating a `Many` element itself

# 0.5.3 / 2018-09-25

### Added

- Added `initial_attributes_url` attribute to `UploadField` and `MultiUploadField`

# 0.5.2 / 2018-08-06

### Added

- Added `clear_query_on_selection` attribute to `SearchMultiSelectionField`

# 0.5.1 / 2018-07-19

### Added

- Add `disabled` attribute to `TextField`
- Add `time_format` and `human_time_format` attributes to `DateTimeField`
- Add `sortable` and `max_height` attributes to `Many`, `MultiSelectionField`, `MultiUploadField`, and `SearchMultiSelectionField`

### Fixed

- Allow falsey attribute values to be passed through in AST

# 0.5.0 / 2018-07-04

### Added

- Add `render_option_control_as` option to search select fields

### Changed

- dry-types dependency updated to 0.13

# 0.4.2 / 2018-07-03

### Fixed

- Errors passed to `#fill` are now properly stored on the form's elements

### Changed

- Private form methods are accessible from within definition blocks

# 0.4.1 / 2018-04-17

### Fixed

- Fixed issue with Form::Validity check crashing while processing `many` elements

# 0.4.0 / 2018-03-28

### Added

- `rich_text_area` field type, support for embedding and validating forms within rich text areas, and rendering the rich text from its native draft.js AST format to HTML
- `search_selection_field` and `multi_search_selection_field` field types
- Various improvements to the upload fields, including support for passing `presign_options`

### Changed

- [BREAKING] Form definition blocks are now evaluated within the context of the form instance's `self`, which mean dependencies can be injected into the form object and accessed from the form definition block. `#dep` within the definition block has thusly been removed.
- [BREAKING] `Formalist::Form` should now be instantiated (`form = MyForm.new`) and then filled with `form.fill(input: input_data, errors: error_messages)`. `Form#fill` returns a copy of the form object with all the elements filled with the input data and error messages as required. `Form#call` has been removed, along with `Formalist::Form::Result` (which was the object returned from `#call`).

### Removed

- Form elements no longer have a `permitted_children` config. For now, this should be handled by convention only.

# 0.3.0 / 2016-05-04

Add support for upload and multi upload fields.

# 0.2.3 / 2016-04-07

Default check_box element values to false.

# 0.2.2 / 2016-02-23

Remove local type coercion using dry-data. We rely on a `Dry::Validation::Schema` to do this now. The form definition API has not yet changed, though. We still require field types to be specified, but there is no longer any restriction over what is entered. We'll remove this in a future release, once we can infer types from the schema.

# 0.2.1 / 2016-02-23

Fix issue where form could not be built with input data with native data types (it presuming input would be HTML form-style input everywhere).

Add default (empty) input data argument for `Form#build`. This allows you simply to call `MyForm.build` for creating a "new" form (i.e. one without any existing input data).

# 0.2.0 / 2016-02-22

Require a dry-validation schema for each form. The schema should completely represent the form's expected data structure.

Update the API to better support the two main use cases for a form. First, to prepare a form with sane, initial input from your database and send it to a view for rendering:

```ruby
my_form = MyForm.new(my_schema)
my_form.build(input) # returns a `Formalist::Form::Result`
```

Then, to receive the data from the posted form, coerce it and validate it (and potentially re-display the form with errors):

```ruby
my_form = MyForm.new(my_schema)
my_form.receive(input).validate # returns a `Formalist::Form::ValidatedResult`
```

The main differences are as such:

* `#build` expects already-clean (e.g. properly structured and typed) data
* `#receive` expects the kind of data that your form will submit, and will then coerce it according to the validation schema, and then send the sanitised output to `#build`
* Calling `#validate` on a result object will validate the input data and include any error messages in its AST

# 0.1.0 / 2016-01-18

Initial release.
