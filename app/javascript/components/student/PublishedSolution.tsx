import React from 'react'
import {
  CommunitySolution as CommunitySolutionProps,
  Iteration,
} from '../types'
import { CommunitySolution, Icon } from '../common'
import { PublishSettings } from './published-solution/PublishSettings'

export type Links = {
  changeIteration: string
  unpublish: string
}

export const PublishedSolution = ({
  publishedIterationIdx,
  iterations,
  solution,
  links,
}: {
  publishedIterationIdx: number | null
  solution: CommunitySolutionProps
  iterations: readonly Iteration[]
  links: Links
}): JSX.Element => {
  return (
    <div className="publish-section">
      <div className="header">
        <h3>Your published solution</h3>
        <PublishSettings
          publishedIterationIdx={publishedIterationIdx}
          iterations={iterations}
          redirectType="private"
          links={links}
        />
      </div>
      <CommunitySolution solution={solution} context="exercise" />
    </div>
  )
}
