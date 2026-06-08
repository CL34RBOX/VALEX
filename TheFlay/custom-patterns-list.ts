import {on} from 'delegated-events'

function copyInput(inputToCopy: HTMLInputElement): HTMLInputElement[] {
  const stateAttribute = 'data-pattern-state'
  const rowVersionAttribute = 'data-pattern-row-version'
  const state = inputToCopy.getAttribute(stateAttribute) ?? ''
  const rowVersion = inputToCopy.getAttribute(rowVersionAttribute) ?? ''
  const input = document.createElement('input')
  input.setAttribute('type', 'hidden')
  input.setAttribute('name', `pattern[][id]`)
  input.setAttribute('value', inputToCopy.value)

  const stateInput = document.createElement('input')
  stateInput.setAttribute('type', 'hidden')
  stateInput.setAttribute('name', `pattern[][state]`)
  stateInput.setAttribute('value', state)

  const rowVersionInput = document.createElement('input')
  rowVersionInput.setAttribute('type', 'hidden')
  rowVersionInput.setAttribute('name', `pattern[][rowVersion]`)
  rowVersionInput.setAttribute('value', rowVersion)
  return [input, stateInput, rowVersionInput]
}

function copySelectedPatternsToBulkDeleteForm(container: Element) {
  const checkedAlerts = container.querySelectorAll<HTMLInputElement>(
    '.js-custom-pattern-list [data-check-all-item]:checked',
  )

  const shouldDisplayCount = checkedAlerts.length > 0
  const countDisplayer = container.querySelector<HTMLElement>('.js-custom-pattern-selected-count')!
  const totalCountDisplay = container.querySelector<HTMLElement>('.js-custom-pattern-total-count')!
  countDisplayer.hidden = !shouldDisplayCount
  totalCountDisplay.hidden = shouldDisplayCount

  const stateAttribute = 'data-pattern-state'
  const patternStates = Array.from(checkedAlerts).map(alert => alert.getAttribute(stateAttribute))
  const allUnpublished = patternStates.every(s => s === 'unpublished')
  const allPublished = patternStates.every(s => s === 'published')

  const removeOnlyUnpublishedInfo = container.querySelectorAll<HTMLElement>(
    '.js-custom-patterns-delete-only-unpublished',
  )
  const removeOnlyPublishedInfo = container.querySelectorAll<HTMLElement>('.js-custom-patterns-delete-only-published')
  const removePublishedAndUnpublishedInfo = container.querySelectorAll<HTMLElement>(
    '.js-custom-patterns-delete-unpublished-and-published',
  )
  const publishedCount = container.querySelectorAll('.js-custom-patterns-published-delete-count')
  const unpublishedCount = container.querySelectorAll('.js-custom-patterns-unpublished-delete-count')
  const formInputs = container.querySelector('.js-custom-patterns-bulk-delete-items')!

  const toggleInfoVisibility = (show: boolean, elems: NodeListOf<HTMLElement>) => {
    for (const elem of elems) {
      if (elem) {
        elem.hidden = !show
      }
    }
  }

  if (allUnpublished) {
    toggleInfoVisibility(false, removeOnlyPublishedInfo)
    toggleInfoVisibility(false, removePublishedAndUnpublishedInfo)
    toggleInfoVisibility(true, removeOnlyUnpublishedInfo)
  }
  if (allPublished) {
    toggleInfoVisibility(false, removeOnlyUnpublishedInfo)
    toggleInfoVisibility(false, removePublishedAndUnpublishedInfo)
    toggleInfoVisibility(true, removeOnlyPublishedInfo)
  }
  if (!allPublished && !allUnpublished) {
    toggleInfoVisibility(false, removeOnlyPublishedInfo)
    toggleInfoVisibility(false, removeOnlyUnpublishedInfo)
    toggleInfoVisibility(true, removePublishedAndUnpublishedInfo)
  }

  const countPublished = patternStates.filter(s => s === 'published').length
  const countUnpublished = patternStates.filter(s => s === 'unpublished').length

  for (const elem of unpublishedCount) {
    if (elem) elem.innerHTML = countUnpublished.toString()
  }
  for (const elem of publishedCount) {
    if (elem) elem.innerHTML = countPublished.toString()
  }

  const publishedPlural = container.querySelectorAll<HTMLElement>('.js-custom-patterns-plural-published')
  const unpublishedPlural = container.querySelectorAll<HTMLElement>('.js-custom-patterns-plural-unpublished')

  for (const elem of publishedPlural) {
    elem.hidden = countPublished === 1
  }
  for (const elem of unpublishedPlural) {
    elem.hidden = countUnpublished === 1
  }

  formInputs.textContent = ''
  for (let i = 0; i < checkedAlerts.length; i += 1) {
    const inputs = copyInput(checkedAlerts[i]!)
    for (const input of inputs) {
      formInputs.appendChild(input)
    }
  }
}

on('change', '.js-custom-pattern-check', ({currentTarget}) => {
  const container = currentTarget.closest<HTMLElement>('.js-custom-pattern-list')!
  const checked = container.querySelector('.js-custom-pattern-check:checked') != null
  const bulkDeleteButton = container.querySelector<HTMLElement>('.js-custom-patterns-bulk-delete')
  const filters = container.querySelector<HTMLElement>('.js-custom-patterns-filters')

  if (bulkDeleteButton) bulkDeleteButton.hidden = !checked
  if (filters) filters.hidden = checked

  copySelectedPatternsToBulkDeleteForm(container)
})
