/**
 * @flow
 */

import 'react-native'
import React from 'react'
import { AssigneePicker } from '../AssigneePicker'
import { type AssigneePickerProps } from '../map-state-to-props'
import renderer from 'react-test-renderer'
import { registerScreens } from '../../../../src/routing/register-screens'
import setProps from '../../../../test/helpers/setProps'
import { cloneDeep } from 'lodash'

registerScreens({})

const template = {
  ...require('../__template__/Assignee.js'),
  ...require('../../../api/canvas-api/__templates__/course'),
  ...require('../../../api/canvas-api/__templates__/assignments'),
  ...require('../../../__templates__/helm'),
}

const defaultProps: AssigneePickerProps = {
  assignees: [template.enrollmentAssignee(), template.enrollmentAssignee({ imageURL: null, id: '9909342324234' })],
  courseID: template.course().id,
  assignmentID: template.assignment().id,
  navigator: template.navigator(),
  handleSelectedAssignee: jest.fn(),
  refreshSections: jest.fn(),
  refreshUsers: jest.fn(),
}

test('render correctly', () => {
  let tree = renderer.create(
    <AssigneePicker {...defaultProps} />
  ).toJSON()
  expect(tree).toMatchSnapshot()
})

test('new assignee props should update correctly', () => {
  const props = cloneDeep(defaultProps)
  const assignees = cloneDeep(props.assignees)
  let picker = renderer.create(
    <AssigneePicker {...props} />
  )

  assignees[0].name = 'Solaire of Astora'
  delete assignees[1]
  assignees.push(template.sectionAssignee())
  assignees.push(template.groupAssignee())
  setProps(picker, { assignees })
  expect(picker.getInstance().state.selected[0]).toMatchObject({
    name: 'Solaire of Astora',
  })
  expect(picker.getInstance().state.selected).toHaveLength(4)
})

test('cancel', () => {
  const fn = jest.fn()
  const navigator = template.navigator({
    dismiss: fn,
  })
  const picker = renderer.create(
    <AssigneePicker {...defaultProps} navigator={navigator} />
  ).getInstance()
  picker.dismiss()
  expect(fn).toHaveBeenCalled()
})

test('done', () => {
  const fn = jest.fn()
  const navigator = template.navigator({
    dismiss: fn,
  })
  const picker = renderer.create(
    <AssigneePicker {...defaultProps} navigator={navigator} />
  ).getInstance()
  picker.done()
  expect(fn).toHaveBeenCalled()
})

test('done with callback', () => {
  const callback = jest.fn()
  const fn = jest.fn(() => {
    callback()
  })
  const navigator = template.navigator({
    dismiss: fn,
  })
  const picker = renderer.create(
    <AssigneePicker {...defaultProps} navigator={navigator} callback={callback} />
  ).getInstance()
  picker.done()
  expect(callback).toHaveBeenCalled()
})

test('add assignee function', () => {
  const fn = jest.fn()
  const navigator = template.navigator({
    show: fn,
  })
  const picker = renderer.create(
    <AssigneePicker {...defaultProps} navigator={navigator} />
  ).getInstance()
  picker.addAssignee()
  expect(fn).toHaveBeenCalled()
})

test('handles adding', () => {
  let assignee = template.enrollmentAssignee({
    id: '999999',
  })
  let picker = renderer.create(
    <AssigneePicker {...defaultProps} />
  ).getInstance()
  picker.handleSelectedAssignee(assignee)
  expect(picker.state.selected.length).toEqual(3)
})

test('cannot add the same assignee two times in a row', () => {
  let assignee = template.enrollmentAssignee({
    id: '999999',
  })
  let picker = renderer.create(
    <AssigneePicker {...defaultProps} />
  ).getInstance()
  picker.handleSelectedAssignee(assignee)
  picker.handleSelectedAssignee(assignee)
  expect(picker.state.selected.length).toEqual(3)
})

test('handles removing', () => {
  let assignee = defaultProps.assignees[0]
  let picker = renderer.create(
    <AssigneePicker {...defaultProps} />
  ).getInstance()
  picker.deleteAssignee(assignee)
  expect(picker.state.selected.length).toEqual(1)
})
