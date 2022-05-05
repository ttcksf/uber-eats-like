import React, {Fragment} from 'react'

export const Foods = ({match}) => {
  return(
    <>
      フード一覧
      <p>restaurantsIdは{match.params.restaurantsId}です</p>
    </>
  )
}
