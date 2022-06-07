import Axios from 'axios'


export default function Bleumi() {
  let response;
  const headers =  {'X-Api-Key': 'c4QzxtjPs6auXxeeY8HSy8HXobls2QlV5shO7PXK'};
  let data;
  
  Axios.post("https://api.bleumi.io/v1", data, {headers: headers}).then(res => {response = res;});

  return(
      <div>
        <b>Bleumi </b>
        <p>{response}</p>    
      </div>   
  )
}




