@section('content')
    <h1>Welcome To {{ $app_name }}</h1>

    {{-- The error / success messaging partial --}}
    @include('messaging')

    @if (count($records) === 1)
        I have one record!
    @elseif (count($records) > 1)
        I have multiple records!
    @else
        I don't have any records!
    @endif
@endsection
