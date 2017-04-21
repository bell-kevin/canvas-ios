/* @flow */

import { mapStateToProps, type AssignmentDueDatesProps } from '../map-state-to-props'

const template = {
  ...require('../../../api/canvas-api/__templates__/assignments'),
  ...require('../../../api/canvas-api/__templates__/users'),
  ...require('../../../redux/__templates__/app-state'),
  ...require('../../../__templates__/react-native-navigation'),
}

test('map state to props should work', async () => {
  const user = template.user()
  const dateID = '123344556666'
  const date = template.assignmentDueDate({ id: dateID })
  const override = template.assignmentOverride({
    id: dateID,
    student_ids: [user.id],
  })
  const assignment = template.assignment({
    all_dates: [date],
    overrides: [override],
  })

  let state: AppState = template.appState({
    entities: {
      assignments: {
        [assignment.id]: { data: assignment },
      },
      users: {
        [user.id]: user,
      },
      courses: {},
      assignmentGroups: {},
      gradingPeriods: {},
    },
    favoriteCourses: [],
  })

  const props: AssignmentDueDatesProps = {
    courseID: '1',
    assignment,
    assignmentID: assignment.id,
    users: {},
    refreshUsers: jest.fn(),
    navigator: template.navigator(),
  }

  let result = mapStateToProps(state, props)
  expect(result).toMatchObject({
    assignment,
    users: {
      [user.id]: user,
    },
  })

  // I don't know why this won't work
  // $FlowFixMe
  state.entities.users = {}
  result = mapStateToProps(state, props)
  expect(result).toMatchObject({
    assignment,
    users: {},
  })
})
